using STEMMA.Domain.Cadastro.Repositories;

public class DeleteTutorUseCase
{
    private readonly ITutorRepository _tutorRepository;

    public DeleteTutorUseCase(
        ITutorRepository tutorRepository)
    {
        _tutorRepository = tutorRepository;
    }

    public async Task ExecuteAsync(Guid id)
    {
        var tutor = await _tutorRepository.ObterPorIdAsync(id);

        if (tutor is null)
            throw new Exception("Tutor não encontrado.");

        await _tutorRepository.RemoverAsync(id);
    }
}