using STEMMA.Application.Cadastro.DTOs.Responses;
using STEMMA.Application.Cadastro.Tutores.Mappers;
using STEMMA.Domain.Cadastro.Repositories;

public class GetTutorByIdUseCase
{
    private readonly ITutorRepository _tutorRepository;

    public GetTutorByIdUseCase(
        ITutorRepository tutorRepository)
    {
        _tutorRepository = tutorRepository;
    }

    public async Task<TutorResponse> ExecuteAsync(Guid id)
    {
        var tutor = await _tutorRepository.ObterPorIdAsync(id);

        if (tutor is null)
            throw new Exception("Tutor não encontrado.");

        return TutorMapper.ToResponse(tutor);
    }
}