using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.Tutores.Mappers;
using STEMMA.Domain.Cadastro.Repositories;

namespace STEMMA.Application.Cadastro.Tutores.UseCases;

public class CreateTutorUseCase
{
    private readonly ITutorRepository _tutorRepository;

    public CreateTutorUseCase(
        ITutorRepository tutorRepository)
    {
        _tutorRepository = tutorRepository;
    }

    public async Task<Guid> ExecuteAsync(
        CreateTutorRequest request)
    {
        var tutor = TutorMapper.ToEntity(request);

        await _tutorRepository.AdicionarAsync(tutor);

        return tutor.Id;
    }
}